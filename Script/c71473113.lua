--Fantasia Knight - Lord
function c71473113.initial_effect(c)
	c:SetUniqueOnField(1,0,71473113)
	--Special Summon Self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71473113,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c71473113.spcon)
	e1:SetOperation(c71473113.spop)
	c:RegisterEffect(e1)
	--Special Summon Pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71473113,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c71473113.sptg1)
	e2:SetOperation(c71473113.spop1)
	c:RegisterEffect(e2)
	--Set Pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71473113,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c71473113.settg)
	e3:SetOperation(c71473113.setop)
	c:RegisterEffect(e3)
	--Special Summon 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71473113,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c71473113.spcost)
	e4:SetTarget(c71473113.sptg2)
	e4:SetOperation(c71473113.spop2)
	c:RegisterEffect(e4)
end
function c71473113.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c71473113.spfilter(c)
	return c:IsSetCard(0x1C1D) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c71473113.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71473113.spfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,2,nil)
end
function c71473113.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71473113.spfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	c:RegisterEffect(e1)
end
function c71473113.filter1(c,e,tp)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x1C1D) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71473113.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c71473113.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71473113.filter1,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71473113.filter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71473113.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71473113.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1C1D)
end
function c71473113.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71473113.filter2,tp,LOCATION_MZONE,0,1,nil) 
		and not Duel.IsExistingMatchingCard(Card.GetSequence,tp,LOCATION_SZONE,0,1,nil,6+7) end
end
function c71473113.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6)==nil or Duel.GetFieldCard(tp,LOCATION_SZONE,7)==nil then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71473113,2))
	local g=Duel.SelectMatchingCard(tp,c71473113.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c71473113.spfilter2(c)
	return c:IsSetCard(0x1C1D) and c:IsFaceup()
end
function c71473113.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71473113.spfilter2,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c71473113.spfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c71473113.filter3(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1C1D) and c:IsType(TYPE_PENDULUM+TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71473113.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c71473113.filter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71473113.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71473113.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71473113.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end