--created & coded by Lyris
--Clarissa, Queen of Stellar Vine #2
function c101010294.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--add counter
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ae3:SetCode(EVENT_REMOVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetOperation(c101010294.acop)
	c:RegisterEffect(ae3)
	--Evolute Counter
	local ae0=Effect.CreateEffect(c)
	ae0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ae0:SetCode(EVENT_CUSTOM+101010294)
	ae0:SetOperation(c101010294.eop)
	c:RegisterEffect(ae0)
	--survival
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_DESTROY_REPLACE)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetTarget(c101010294.reptg)
	ae1:SetOperation(c101010294.repop)
	c:RegisterEffect(ae1)
	--banish
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_QUICK_O)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetCode(EVENT_FREE_CHAIN)
	ae2:SetCountLimit(1)
	ae2:SetCost(c101010294.cost)
	ae2:SetOperation(c101010294.op)
	c:RegisterEffect(ae2)
	if not c101010294.global_check then
		c101010294.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010294.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010294.evolute=true
c101010294.material1=function(mc) return mc:GetLevel()==4 and mc:IsRace(RACE_FAIRY) and mc:IsFaceup() end
c101010294.material2=function(mc) return mc:GetLevel()==4 and mc:IsAttribute(ATTRIBUTE_WATER) and mc:IsFaceup() end
function c101010294.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
end
function c101010294.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(Card.IsSetCard,1,c,0x785e) then
		c:AddCounter(0x1,1)
		if c:GetCounter(0x1)==3 then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+101010294,e,0,0,tp,0)
		end
	end
end
function c101010294.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x1,3,REASON_EFFECT)
	c:AddCounter(0x1088,1)
end
function c101010294.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1088)>2 end
	return Duel.SelectYesNo(tp,aux.Stringid(101010294,0))
end
function c101010294.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1088,1,REASON_EFFECT)
end
function c101010294.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,2,REASON_COST)
end
function c101010294.filter(c,e,tp)
	return c:IsSetCard(0x785e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010294.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil):RandomSelect(tp,1)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and bit.band(tc:GetFirst():GetOriginalType(),TYPE_FUSION)==TYPE_FUSION and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101010294.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
