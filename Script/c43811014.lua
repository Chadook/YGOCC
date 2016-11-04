--Nightmare of the Phantasm
function c43811014.initial_effect(c)
	--Fusion Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c43811014.fscondition)
	e1:SetOperation(c43811014.fsoperation)
	c:RegisterEffect(e1)
	--Material Check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c43811014.matcheck)
	c:RegisterEffect(e2)
	--Special Summon Success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c43811014.effop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Special Summon 2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43811004,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c43811014.sptg)
	e4:SetOperation(c43811014.spop)
	c:RegisterEffect(e4)
end
function c43811014.ffilter(c,mg)
	return c:IsSetCard(0x90e)
end
function c43811014.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	if gc then return c43811014.ffilter(gc) and g:IsExists(c43811014.ffilter,1,gc) end
	local g1=g:Filter(c43811014.ffilter,nil)
	if chkf~=PLAYER_NONE then
		return g1:FilterCount(Card.IsOnField,nil)~=0 and g1:GetCount()>=2
	else return g1:GetCount()>=2 end
end
function c43811014.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=eg:FilterSelect(tp,c43811014.ffilter,1,63,gc)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(c43811014.ffilter,nil)
	if chkf==PLAYER_NONE or sg:GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,2,63,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,63,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c43811014.matcheck(e,c)
	local g=c:GetMaterial()
	e:SetLabel(g:FilterCount(Card.IsSetCard,nil,0x90e))
end
function c43811014.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x90e)
end
function c43811014.atkval(e,c)
	return Duel.GetMatchingGroupCount(c43811014.afilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*200
end
function c43811014.effop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if ct~=0 then
		if ct>=2 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(c43811014.atkval)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
			local e0=e1:Clone()
			e0:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e0)
		end
		if ct>=3 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetValue(aux.tgval)
			e2:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e2)
		end
		if ct>=4 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetValue(c43811014.efilter)
			e3:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e3)
		end
		if ct>=5 then
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(43811014,0))
			e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e4:SetType(EFFECT_TYPE_IGNITION)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCountLimit(1)
			e4:SetTarget(c43811014.sptg)
			e4:SetOperation(c43811014.spop)
			e4:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e4)
		end
	end
end
function c43811014.efilter(e,re,tp)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c43811014.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x90e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c43811014.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK) and c:IsControler(1-tp) and c43811014.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c43811014.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c43811014.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c43811014.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43811014.filter(c,e,tp)
	return c:IsSetCard(0x90e) and c:IsType(TYPE_MONSTER) and not c:IsCode(43811014) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43811014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43811014.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c43811014.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c43811014.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end