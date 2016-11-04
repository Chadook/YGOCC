--Thunder Strike Blitz
function c20150005.initial_effect(c)
	--special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(20150005,0))
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20150005.spcon)
	c:RegisterEffect(e1)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20150005,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c20150005.eqtg)
	e3:SetOperation(c20150005.eqop)
	c:RegisterEffect(e3)
	--Main Phase 2
	local ee=Effect.CreateEffect(c)
	ee:SetDescription(aux.Stringid(20150005,2))
	ee:SetCategory(CATEGORY_UPDATE_DEFENSE)
	ee:SetType(EFFECT_TYPE_IGNITION)
	ee:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ee:SetRange(LOCATION_MZONE)
	ee:SetCountLimit(1)
	ee:SetTarget(c20150005.mp2tg)
	ee:SetOperation(c20150005.mp2op)
	c:RegisterEffect(ee)
end

function c20150005.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
		and c:GetLevel()==4
		and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsRace(RACE_MACHINE)
		and c:IsFaceup()
end

function c20150005.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20150005.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c20150005.eqfilter(c,handler)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetLevel()==4
end

function c20150005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20150005.eqfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c20150005.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c20150005.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end

function c20150005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c20150005.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(400)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--double attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_EQUIP)
	e11:SetCode(EFFECT_EXTRA_ATTACK)
	e11:SetValue(1)
	c:RegisterEffect(e11)
end

function c20150005.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function c20150005.mp2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end

function c20150005.mp2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1200)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end